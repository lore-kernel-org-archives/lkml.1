Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbXENT2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbXENT2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXENT2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:28:42 -0400
Received: from smtp25.orange.fr ([193.252.22.23]:31638 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbXENT2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:28:41 -0400
X-ME-UUID: 20070514192839948.E777D1C000A0@mwinf2559.orange.fr
Subject: Re: tracking down disk spinups.
From: Xavier Bestel <xavier.bestel@free.fr>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4648B789.7080905@goop.org>
References: <20070514185734.GM27604@redhat.com>  <4648B789.7080905@goop.org>
Content-Type: text/plain; charset=ISO-8859-15
Date: Mon, 14 May 2007 21:28:34 +0200
Message-Id: <1179170914.2397.4.camel@bip.parateam.prv>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 14 mai 2007 à 12:24 -0700, Jeremy Fitzhardinge a écrit :
> I don't think you can change filesystem types with remount.  Doesn't
> that just change flags on an existing mount? 

+1


