Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbYFOKWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbYFOKWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 06:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbYFOKVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 06:21:41 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:27486 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543AbYFOKVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 06:21:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GyP37ESLG43d0wZd6opxzPUDBvyG1fvKe6y/Up9Z+h7sK/zPS+hzhlRiHBE9amE80Q
         39OrvpRoKhFr/2Ov5MCpQLvWjG3g7QlV6Y/ph/mdb9lVvd3JyQDXsQbbnYE1PQMUR06v
         GoUIAPjcV6momzsnYo3VCF34oVzaUTvnN2sF8=
Subject: Re: [Bug 10892] Sometime (often) X come out blank (black screen)
	on cold boot - Intel chipset
From: Romano Giannetti <romano.giannetti@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Jn7irxIunJK.A.UPD.vIDVIB@albercik>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	 <Jn7irxIunJK.A.UPD.vIDVIB@albercik>
Content-Type: text/plain
Date: Sun, 15 Jun 2008 12:21:31 +0200
Message-Id: <1213525291.15067.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-14 at 22:12 +0200, Rafael J. Wysocki wrote:

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10892
> Subject		: Sometime (often) X come out blank (black screen) on cold boot - Intel chipset
> Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
> Date		: 2008-06-10 05:33 (5 days old)
> References	: http://lkml.org/lkml/2008/6/10/137

It happened, again, with the new Ubuntu x-intel driver. Rebooting with
nousplash solved the problem, but alas, sometime simply rebooting solves
the problem. It seems a race...

Romano

