Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbZJIAXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbZJIAXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 20:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbZJIAXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 20:23:39 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:49940 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbZJIAXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 20:23:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=u20bEfSEJUWHOuJIB3lt3Koz4Zy2/FK2Tpln0W5WSatdn13TbuAE4kZZ/919Uf1e1F
         CLFULXdHHLdaVttT153dfEwKLbp/Yp9HO/H6FmuUafIAw674aD03L5d4nhial7T5t6S/
         w2wl8l4e1AWPZabXj/lDvPNh6mYRp881IbhkE=
MIME-Version: 1.0
In-Reply-To: <a8e1da0910080440u6367cdcbq55f57d6a16d97533@mail.gmail.com>
References: <haj471$fn8$1@ger.gmane.org>
	 <58965d8a0910071618s2420fed1k4ccde4823e57f756@mail.gmail.com>
	 <haj8uj$fn8$2@ger.gmane.org>
	 <a8e1da0910072255r38f95e59lf9559b4ecd1cc9d2@mail.gmail.com>
	 <cdb43e8a0910080331l1faa426cq9c2e1e0467003ec9@mail.gmail.com>
	 <a8e1da0910080351w4fe8827eyd583eb903748ed92@mail.gmail.com>
	 <a8e1da0910080440u6367cdcbq55f57d6a16d97533@mail.gmail.com>
Date: Thu, 8 Oct 2009 19:23:01 -0500
X-Google-Sender-Auth: 136bf8799f82d274
Message-ID: <cdb43e8a0910081723v1adeea80p6a1360ae22a3afcf@mail.gmail.com>
Subject: Re: iso9660 mount problem
From: Jack Byer <ojbyer@usa.net>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So it must be an apple hfs disc, (or hybrid disc?).
> Maybe you may try mount it as hfs, this problem is not relevant to iso9660.

I can mount the disc as hfsplus but it shows the OS X contents instead
of the Windows contents.
