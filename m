Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbXKMPVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbXKMPVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbXKMPVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:21:11 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:40937 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbXKMPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:21:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sHcsLbRluC6RS/dZO31msrRVXa3DvoF8nSKEISoSU3Fzw3eWG8aLGZGEvX8a/IJ9M5boEkYfmYir2Z2IA8cyh1NAvcZJqQnIdqPGYcuY7dhe5C51HZu3X2J4+HpIQ6aga7a0GlMREc3i8ZimH5n22bmPEazX7ENm9ELXhJPoFdc=
Message-ID: <58cb370e0711130721g49a28666u6d315c1412b0c855@mail.gmail.com>
Date: Tue, 13 Nov 2007 16:21:06 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [BUG] New Kernel Bugs
Cc: "Natalie Protasevich" <protasnb@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-ide@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-input@atrey.karlin.mff.cuni.cz, bugme-daemon@bugzilla.kernel.org
In-Reply-To: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com>
	 <20071113031553.3c7b5c16.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 13, 2007 12:15 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 12 Nov 2007 22:42:32 -0800 "Natalie Protasevich" <protasnb@gmail.com> wrote:
>
> > This is the listing of the open bugs that are relatively new, around
> > 2.6.22 and up. They are vaguely classified by specific area.
> > (not a full list, there are more :)

[...]

> > IDE/SATA=========================================================

[...]

> > DVD-RAM umount and disk free bug
> > http://bugzilla.kernel.org/show_bug.cgi?id=9265
> > Kernel: 2.6.15  (asked to try current kernel)
>
> No response from developers

Bug was filled under IO/Storage-Other so is it assigned to
<other_other@kernel-bugs.osdl.org>.

Could be a FS problem as well but it is the best to wait for
confirmation with 2.6.23 before proceeding further...
