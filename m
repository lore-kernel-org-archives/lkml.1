Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbYJBEzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbYJBEzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 00:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbYJBEzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 00:55:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbYJBEzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 00:55:44 -0400
Date: Wed, 1 Oct 2008 21:55:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jean-Marc Spaggiari" <jean-marc@spaggiari.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: IT8720: it87.c update
Message-Id: <20081001215508.629f32cb.akpm@linux-foundation.org>
In-Reply-To: <79c9d4530810011732j2fc72f5n357f026b3df475d@mail.gmail.com>
References: <79c9d4530810011732j2fc72f5n357f026b3df475d@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 20:32:10 -0400 "Jean-Marc Spaggiari" <jean-marc@spaggiari.org> wrote:

> I just did some modifications to drivers/hwmon/it87.c in order to
> handle the IT8720 chipset and I would like to know where I can propose
> my modifications.

Please send a patch as per Documentation/SubmittingPatches to

lm-sensors@lm-sensors.org
linux-kernel@vger.kernel.org
akpm@linux-foundation.org
