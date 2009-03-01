Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZCADSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZCADSJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 22:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbZCADR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 22:17:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48146 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbZCADRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 22:17:55 -0500
Message-ID: <49A9FCEB.9090504@redhat.com>
Date: Sat, 28 Feb 2009 22:11:39 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix DMI for EFI
References: <49A9F597.4010601@redhat.com> <86802c440902281856h1dc950e7me8568cd5dca59da9@mail.gmail.com>
In-Reply-To: <86802c440902281856h1dc950e7me8568cd5dca59da9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

probe_roms() needs to be after dmi?

Brian


Yinghai Lu wrote:
> it will break dmi check for 64k ram corruption...
>
>
> YH
>   

