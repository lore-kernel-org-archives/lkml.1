Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXEJAEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXEJAEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbXEJAEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:04:30 -0400
Received: from gw.goop.org ([64.81.55.164]:44127 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751AbXEJAEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:04:30 -0400
Message-ID: <46426194.3040403@goop.org>
Date: Wed, 09 May 2007 17:04:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com>
In-Reply-To: <20070510000119.GO85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> Seems very unlikely. Have you unmounted and mounted the filesystem
> (or rebooted or suspended) between the files being seen good and
> the files being seen bad?
>   

There was definitely a suspend-resume, and maybe a reboot.  I'll try
again later on.

    J
