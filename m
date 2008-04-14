Return-Path: <linux-kernel-owner+w=401wt.eu-S1763614AbYDNSgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763614AbYDNSgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760636AbYDNSgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:36:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:53522 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483AbYDNSgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:36:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NQd9GaMBIhnGafpJYNAE0JR1bFoWIXulBVl2+N8tT227x6W1behCFDyj+WeQ8gz8Va2PY5zpMLtBg5A8Iw5kNhezt7Hi1aTaXbhe07irv6fFRk2ky4zmF5FICs9ciftaaNxjlx9uUgsyZIS/lhAWkE9t8OzMWtEEn/C/syEhj0M=
Message-ID: <4a4634330804141136xcaf098esf02539bf76917781@mail.gmail.com>
Date: Mon, 14 Apr 2008 13:36:42 -0500
From: "Shirish Pargaonkar" <shirishpargaonkar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: valid task structure and wake_up_process
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How do I check whether a task is valid before calling wake_up_process() with
that task structure pointer?
I could call wake_up_process with a task structure that is corrupt or incorrect
and that could cause a system crash, so I wanted to do a sanity check of
the task structure.

I do not subscribe to this list, so please copy me you responses.

Regards,

Shirish
