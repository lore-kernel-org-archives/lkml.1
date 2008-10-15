Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbYJOLgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbYJOLgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYJOLga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:36:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:47280 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751851AbYJOLg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:36:29 -0400
Date: Wed, 15 Oct 2008 13:36:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Douglas Landgraf <dougsland@gmail.com>,
       Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [PATCH 3/3] Don't let Avermedia Radio FM800 be detected as a
 normal HID device
In-Reply-To: <20081014231059.13833f96@pedra.chehab.org>
Message-ID: <alpine.LNX.1.10.0810151335360.26779@jikos.suse.cz>
References: <20081014111023.04c8a059@pedra.chehab.org> <alpine.LNX.1.10.0810142222330.26779@jikos.suse.cz> <alpine.LNX.1.10.0810142225480.26779@jikos.suse.cz> <20081014231059.13833f96@pedra.chehab.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008, Mauro Carvalho Chehab wrote:

> > OK, now I see, it's radio-mr800 driver. I will update the changelog 
> > accordingly. Thanks.
> Yes.
> Since the radio driver is already upstream, it would be interesting to have
> this patch also for 2.6.28.

It went to Linus in the pull request I sent last night.

-- 
Jiri Kosina
SUSE Labs
