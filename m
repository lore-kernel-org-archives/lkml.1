Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbXCIJaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbXCIJaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXCIJaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:30:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:35861 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXCIJaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:30:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=WyVInc9SJ1IS7/k0fCLd5Z6/FULofufEvtx1yCBR2poekIQJmDUvEN08/6koKEEDr3LrNM/A8xGHvzO9auUgrPsBlaXQE9qoyjgA7UrH9UsM9ekr/ZBCS9XT+4p6shcoEa6qzAskQCyPk2iMtLXdrjHrTmsMPjS9HdqnxDkoo0U=
From: Eric Lacombe <tuxiko@free.fr>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.19.2: maybe a bug inside the r8169 network driver (was Re: Linux 2.6.19.2: Freeze with CIFS mount)
Date: Fri, 9 Mar 2007 10:30:14 +0100
User-Agent: KMail/1.9.6
References: <OFC7B98576.0C582E30-ON87257274.0014583D-86257274.00153815@us.ibm.com> <200703061742.36467.tuxiko@free.fr> <200703072048.29398.tuxiko@free.fr>
In-Reply-To: <200703072048.29398.tuxiko@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091030.15042.tuxiko@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just to alert potential readers, that the bug is now discussed there :
http://bugzilla.kernel.org/show_bug.cgi?id=8143

	Eric Lacombe
