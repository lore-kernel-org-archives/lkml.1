Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZHKMtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZHKMtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZHKMtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:49:06 -0400
Received: from mailhost13.gawab.com ([66.220.20.13]:42766 "HELO
	info15.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753729AbZHKMtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:49:01 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH, RFC] ext3: Update Kconfig description of EXT3_DEFAULTS_TO_ORDERED
Date: Tue, 11 Aug 2009 06:49:20 +0300
User-Agent: KMail/1.5
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
References: <1249934623-15939-1-git-send-email-tytso@mit.edu>
In-Reply-To: <1249934623-15939-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908110649.20277.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o wrote:
> +	  "data=ordered" mode can also result in major performance
> +	  problems, including seconds-long delays before an fsync()
> +	  call returns.	 For details, see:
> +
> +	  http://ext4.wiki.kernel.org/index.php/Ext3_data_mode_tradeoffs

Why isn't the fsync problem fixable?


Thanks!

--
Al

