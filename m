Return-Path: <linux-kernel-owner+w=401wt.eu-S1761458AbZFMWYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458AbZFMWYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZFMWYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:24:42 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:45318 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZFMWYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:24:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=t8pRYab03LC0q3xcbjnMYBjsUvms89K/LYH7OAepwtrN5UXBcJ/sgxuSadisWu+Fpp
         d3j4gKQn6RniXFo4hiaJaVuxialMaCTQimJOXZw7eqvnUzmitCkL6IfqPs1HOWXKF0iT
         hDQC6Y0REfE/Yt8+ihpRQbsB3qrSPW9HJL+OU=
Date: Sun, 14 Jun 2009 00:24:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] ftrace: document basic ftracer/ftracer graph
	needs
Message-ID: <20090613222440.GA5986@nowhere>
References: <1244623722-6325-2-git-send-email-vapier@gentoo.org> <1244667129-27630-1-git-send-email-vapier@gentoo.org> <8bd0f97a0906120110g3088048fl58270a850ac00f85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906120110g3088048fl58270a850ac00f85@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 04:10:03AM -0400, Mike Frysinger wrote:
> On Wed, Jun 10, 2009 at 16:52, Mike Frysinger wrote:
> > While implementing ftracer and ftracer graph support, I found the exact
> > arch implementation details to be a bit lacking (and my x86 foo ain't
> > great).  So after pounding out support for the Blackfin arch, start
> > documenting the requirements/details.
> 
> have you merged this ?  i have a small update to it (remind people to
> export the mcount symbol), but dont know if you'd like a fresh patch
> or one on top of this.
> -mike


Hi,

It hasn't been merged, you can safely send a v3.

Thanks.

