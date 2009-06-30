Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbZF3Eas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbZF3Eas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 00:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZF3Eai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 00:30:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:54823 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZF3Eai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 00:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=P5lLNU1cV9l4wBb6d+l8iPmrTGPiidHDYVUMpmiP/d6OdXj/m/H/TPU4F88o1f48ZA
         BA5HJn9c+25HZMjP7TzfqnP+HAw2ac8OvwCO/w7Psj4ZHn0gypN7guqRGJFv9UUIBf7z
         FWMXAjIOHM8FxAeeCFEzQ7PDLgsYywVGN9qwA=
Message-ID: <4A499531.4040001@gmail.com>
Date: Mon, 29 Jun 2009 21:31:45 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: need help figuring out what makes my wireless"iwconfig" not respond
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from 2.6.31-rc1 to present there was a couple of commits for
wireless. prior to that the wireless on my machine(imac)
was o.k.,
Now the wireless does work(streams music,t.v. etc..)
but when I look at iwconfig there's nothing no info.
(I use wicd as my connection manager, and in the bottom corner
of the screen the transmit power is down to almost nothing,
causing wicd to constantly reconnect)

out of a random guess what commit might have caused this, so I can at least
fix this over here(that is until the manufacturer comes out with a new
version). I can go in and individually revert all of the wireless, but 
before that
I want a quick lead.

any ideas?

regards,

Justin P. Mattock
