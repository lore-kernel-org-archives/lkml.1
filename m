Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYGCL7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYGCL7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 07:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYGCL5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 07:57:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbYGCL5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:57:00 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 55/84] ACPI: video: fix brightness allocation
Date: Thu, 3 Jul 2008 13:56:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Julia Jomantaite <julia.jomantaite@gmail.com>,
       Len Brown <len.brown@intel.com>, ak@linux.intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>
References: <1214631868-1715-1-git-send-email-lenb@kernel.org> <985af41a38b76827c1f0692cf18469ebf0c4475b.1214631214.git.len.brown@intel.com> <200807021857.45814.trenn@suse.de>
In-Reply-To: <200807021857.45814.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031356.56784.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2008 18:57:44 Thomas Renninger wrote:
> On Saturday 28 June 2008 07:43:59 Len Brown wrote:
> > From: Julia Jomantaite <julia.jomantaite@gmail.com>
> >
> > Fix use of uninitialized device->brightness.
>
> Can this one be left out.
It's fine. I go on top. It has what I need and already got reviewed.
I will try to post my things later today.

Sorry for the noise.

   Thomas
