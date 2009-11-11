Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbZKKXaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbZKKXaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 18:30:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759589AbZKKXaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 18:30:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759543AbZKKXaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 18:30:02 -0500
Date: Wed, 11 Nov 2009 15:29:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Feuerer <peter@piie.net>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>,
       lenb@kernel.org, Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH 2/2] acerhdf: Added new BIOS versions
Message-Id: <20091111152935.5fad5071.akpm@linux-foundation.org>
In-Reply-To: <20091109185335.26836808.peter@piie.net>
References: <20091109185105.6028c057.peter@piie.net>
	<20091109185335.26836808.peter@piie.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Len, patch 1/2 looks like 2.6.32 material to me?

Ordinarily I'd consider an add-device-support patch like 2/2 to be
2.6.32 material also, but this one looks a bit large and scary for that
treatment.
