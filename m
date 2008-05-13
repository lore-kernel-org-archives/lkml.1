Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbYEMTpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbYEMTpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 15:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbYEMTpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 15:45:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:58513 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbYEMTpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 15:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qbgbtP36sDdSyPuYe8Yvb38WYOAeKFtGHsnTdN7d92jLobj/QX+tlhl9xPWHEY2vvX9VqkBbzIgFETL4yPlHtTluRBEfmPiZCKvDKV15ui3A05ENqDkHXL1reQ5R758jX+eqkMU1+4Kxn6oPSXvhxjEt8L/rwr3Y1i+X3ju/OH4=
Message-ID: <84144f020805131245l13d9770hce8447f5665a5289@mail.gmail.com>
Date: Tue, 13 May 2008 22:45:41 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "=?ISO-8859-1?Q?St=E9phane_ANCELOT?=" <sancelot@free.fr>
Subject: Re: detecting kernel mem leak
Cc: "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4829566B.7090804@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1209462094.4816ed4e93977@imp.free.fr>
	 <84144f020804290546h666983aci77fbb08eb507e777@mail.gmail.com>
	 <Pine.LNX.4.64.0804290956360.10847@schroedinger.engr.sgi.com>
	 <4821C526.8030901@free.fr>
	 <Pine.LNX.4.64.0805071020210.3173@schroedinger.engr.sgi.com>
	 <4829566B.7090804@free.fr>
X-Google-Sender-Auth: bae858a17e8acf04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 11:50 AM, Stéphane ANCELOT <sancelot@free.fr> wrote:
>  The are some signifiant changes in slabinfo but now, I do not know where
>  to search ?

Can you please post your full dmesg, /proc/slabinfo and /proc/meminfo
output please?
