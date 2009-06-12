Return-Path: <linux-kernel-owner+w=401wt.eu-S1758327AbZFLILD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbZFLILD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761860AbZFLIKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:10:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:3313 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbZFLIK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:10:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fp/GnHawQIWfhppfu6oiN3TABA7H6owbtZg791I234qYBZdsHl7cuPL3cC7Rr8khwy
         3dfkdwZ7a4KrAfY/0naaW3b5YL0u9bKzMgRM1InaQ/UEK7H7leZ8p369O5s9oe1L2lKH
         eTO/orsZfNlD9UobRXZZvnzVePdrRcjcjja0E=
MIME-Version: 1.0
In-Reply-To: <1244667129-27630-1-git-send-email-vapier@gentoo.org>
References: <1244623722-6325-2-git-send-email-vapier@gentoo.org> 
	<1244667129-27630-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 04:10:03 -0400
Message-ID: <8bd0f97a0906120110g3088048fl58270a850ac00f85@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] ftrace: document basic ftracer/ftracer graph needs
To: Mike Frysinger <vapier@gentoo.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 16:52, Mike Frysinger wrote:
> While implementing ftracer and ftracer graph support, I found the exact
> arch implementation details to be a bit lacking (and my x86 foo ain't
> great).  So after pounding out support for the Blackfin arch, start
> documenting the requirements/details.

have you merged this ?  i have a small update to it (remind people to
export the mcount symbol), but dont know if you'd like a fresh patch
or one on top of this.
-mike
