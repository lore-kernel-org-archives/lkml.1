Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZGKLv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZGKLv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZGKLvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:51:49 -0400
Received: from solo.fdn.fr ([80.67.169.19]:42213 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbZGKLvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:51:49 -0400
Date: Sat, 11 Jul 2009 13:51:36 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: xorg@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: SIGQUIT from tty layer
Message-ID: <20090711115136.GW5531@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	xorg@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090709143141.GA17551@ben-laptop> <20090709150047.GE5328@const.famille.thibault.fr> <20090709171816.GA6046@ben-laptop> <20090710183346.GA7699@const.famille.thibault.fr> <20090711111659.GD31623@platonas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090711111659.GD31623@platonas>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marius Gedminas, le Sat 11 Jul 2009 14:16:59 +0300, a écrit :
>   "a set of 'stty' calls in the init scripts, that (amazingly) reset the
>    isig flag on the current vt (which in our case is the X vt). For
>    anyone ignorant of the vile mess of consequences that means
>    (obviously) your X server gets a SIGQUIT when you press enter."
>         -- http://www.gnome.org/~michael/blog/2009-05-29.html

Oh joy.

Samuel
