Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYI0XIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYI0XIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 19:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbYI0XIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 19:08:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:5919 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYI0XIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 19:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=jv9gyB3TS4wQ++fT5MvOZM3zQfhE3zyHbHnBjlXOoUC2GZF2yYjy2NSpeOTaxhSabR
         9rxCe0trbuJ+j6ujWMxM3uRtg1CQUL1VFiycOcdbdPt+5Kr6qgfwkwZ3LusoAigp0dEl
         AtPcu12khmK9TGX1b0LvUpYmnE1qD4FxoK38Y=
Message-ID: <48DEBCE9.3000002@gmail.com>
Date: Sun, 28 Sep 2008 03:08:25 +0400
From: Ivan Zorin <ivan.a.zorin@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [question] "copy-on-write" in ext4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, everybody. I have a question to ext4 filesystem developers. Could 
you tell me please, have you planned to implement (no matter, how soon) 
in ext4 some "copy-on-write" feature? If you have, then how it will be 
looks like (and how soon :-) ?
If you haven't, then did you think about ability to implement such 
feature and how it could be?
