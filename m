Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbYJNWLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbYJNWLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYJNWLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:11:38 -0400
Received: from smtp8-g19.free.fr ([212.27.42.65]:41313 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYJNWLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:11:38 -0400
Date: Wed, 15 Oct 2008 00:11:36 +0200
From: FD Cami <francois.cami@free.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jiri Kosina <jikos@jikos.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix numlock led on Dell keyboard (413c:2105)
Message-ID: <20081015001136.1c73fc4f@moria>
In-Reply-To: <20081015000314.40845354@moria>
References: <20081014102821.2693b15e@pedra.chehab.org>
	<20081015000314.40845354@moria>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008 00:03:14 +0200
FD Cami <francois.cami@free.fr> wrote:

> On Tue, 14 Oct 2008 10:28:21 -0200
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
> > This keyboard needs to re-sync numlock after probing.
> 
> Do you mean, when you plug one, the numlock LED is on but numlock
> may be off ? 

Please ignore that one, I found your post from last week explaining
the issue. 

Francois
