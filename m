Return-Path: <linux-kernel-owner+w=401wt.eu-S1759670AbXIBUYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbXIBUYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXIBUXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:23:18 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:44704 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbXIBUXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s1uj7WBRStGuMVFcTW08ek83fllHIzs861GzGFjWRQZiOUOTyGOnfYZ9SzVBNur9kW4wzF4fDDC4WEkxqVpw4lReEnhKG+zMKasywByPJdoCFE/VNjVGeraKjQBRcQrAl3hSBHpQUGqrTabp4CBQIxozvTIl2D8moOhf3BJBhYs=
Message-ID: <9a8748490709021323k3d4adbddv53346aacdd66ab57@mail.gmail.com>
Date: Sun, 2 Sep 2007 22:23:16 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Satyam Sharma" <satyam@infradead.org>
Subject: Re: [PATCH -mm] sisusbvga: Fix bug and build warnings
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Thomas Winischhofer" <thomas@winischhofer.net>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <alpine.LFD.0.999.0709030159320.29617@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
	 <alpine.LFD.0.999.0709030136140.29617@enigma.security.iitk.ac.in>
	 <9a8748490709021311q179ab8c6iee7ffb14f6a2eb80@mail.gmail.com>
	 <alpine.LFD.0.999.0709030159320.29617@enigma.security.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/07, Satyam Sharma <satyam@infradead.org> wrote:
> Hi Jesper,
>
>
> On Sun, 2 Sep 2007, Jesper Juhl wrote:
> >
> > > -       if (!(interface = usb_find_interface(&sisusb_driver, subminor))) {
> > > -               dev_err(&sisusb->sisusb_dev->dev, "Failed to find interface¥n");
> >
> > Odd how in your patch the line ends with  "¥n"  but if I look in my
> > local copy of the source tree I see  "\n".
>
> Odd, indeed. I see correct '\n' in the mail I sent, but in your mail
> here it's coming out wrong -- lkml.org shows badness as well. Hmmm,
> "insert file" using ^R in alpine never gave any problems before ...

Hmm, I often use pine and ^R myself without trouble - haven't upgraded
to alpine yet, but something certainly is wrong.
I see the badness in your mail both in the gmail web interface and
kmail. So I guess it is caused on your end.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
