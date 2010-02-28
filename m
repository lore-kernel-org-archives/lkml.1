Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968000Ab0B1OGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 09:06:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:46970 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935913Ab0B1OGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 09:06:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=W/A1P0+sRDURXgYnEh/a5AMWSZmQbKBDOLpFoUuWEWSn8RU/CLP6lcFBh7XDa/nkSR
         VPXyJQjZtdEJWhQ3LY2KiDGS1SWupDHwTT4G/g2+nJAeY81S47mYlW6aa9CuemXaY6eF
         3ITWwvTDJKM57D4AKlg8lSOXnitjADj3XoCIw=
MIME-Version: 1.0
In-Reply-To: <20100227221310.GA5455@localhost.localdomain>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
	 <1267289508-31031-67-git-send-email-andrea.gelmini@gelma.net>
	 <20100227221310.GA5455@localhost.localdomain>
Date: Sun, 28 Feb 2010 15:06:21 +0100
X-Google-Sender-Auth: d1d67f8ea73f4b26
Message-ID: <9cdbb57f1002280606j6d6ca697k21f42cff87d685de@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH 66/66] arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h: 
	Checkpatch cleanup
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-user@lists.sourceforge.net,
       user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/27 Jeff Dike <jdike@addtoit.com>:
Hi Jeff,
   and thanks for your reply.

> Don't you have anything better to do with your time?

It's a dirty job, but somebody has to do it...
Enlighted by Greg's talk at FOSDEM¹ I sent him some patches (nothing
more than boring things for a real programmer, but a good solitaire
alternative for a rookie like me).

These patches are just a try to see if there are other subtree
maintainers interested in stuff like this.

Ciao,
Andrea




----------------------------
¹ http://bit.ly/9d3Ql3
