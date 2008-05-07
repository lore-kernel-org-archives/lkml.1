Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbYEGG4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbYEGG4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761593AbYEGG4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:56:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:17855 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760393AbYEGG4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TrIBqD7QIsU5dZEkxiCouB82trj5QnNUHQSJ7Z/6xIcheodtzebsOeL0yJJ7Io9Gsc3OPUqSzod9/Fq9a3HwTk68/7fmsSdeQ0cSDawgHhR9TPy534yyPM1nw7UVPab3U/Br3p0JdeYl8UnNzFHORB+hEBrIvg98tICd79neNgY=
Message-ID: <8bd0f97a0805062356r637a87c0p5436ebf742631970@mail.gmail.com>
Date: Wed, 7 May 2008 02:56:22 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: monstr@seznam.cz
Subject: Re: LTP for no MMU systems
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, "Arnd Bergmann" <arnd@arndb.de>
In-Reply-To: <48214CAA.3080008@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48206ECF.9090005@seznam.cz>
	 <8bd0f97a0805060749j28cb6fe6wfbdf0d3948d2f417@mail.gmail.com>
	 <48207888.3070107@seznam.cz>
	 <8bd0f97a0805060837x530bc130vd5b15392d5549c3d@mail.gmail.com>
	 <48214CAA.3080008@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 2:31 AM, Michal Simek <monstr@seznam.cz> wrote:
> Thanks Mike.

it would seem they dont have a page to track results exactly.  the
scripts we have to run thins are here:
http://blackfin.uclinux.org/gf/project/uclinux-dist/scmsvn/?action=browse&path=/trunk/testsuites/ltp/

hope it helps
-mike
