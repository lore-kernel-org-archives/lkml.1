Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbZAYRtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbZAYRtD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 12:49:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbZAYRsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 12:48:52 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:39237 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZAYRsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 12:48:52 -0500
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jan 2009 12:48:50 EST
Date: Sun, 25 Jan 2009 18:37:46 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Lierdakil <root@livid.pp.ru>
Cc: hdegoede@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: GSPCA PAC207 patch to support genius ilook 111 webcam
Message-ID: <20090125183746.45ee2875@free.fr>
In-Reply-To: <4c57f5990901250748j7fffc4fv3150821156ce47a2@mail.gmail.com>
References: <4c57f5990901250748j7fffc4fv3150821156ce47a2@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2009 18:48:34 +0300
Lierdakil <root@livid.pp.ru> wrote:

> It figures, that GSPCA PAC207 driver does not "know", that it can
> support genius i-look 111 webcam.
> The following patch simply adds usb ID of Genius iLook 111 to usb_de
> list of GSPCA PAC207 subdriver.

Thank you. I applied your patch to my repository.

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
