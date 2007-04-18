Return-Path: <linux-kernel-owner+w=401wt.eu-S2992938AbXDRRm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992938AbXDRRm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 13:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992939AbXDRRm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 13:42:58 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:50995 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992938AbXDRRm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 13:42:57 -0400
Date: Wed, 18 Apr 2007 13:42:56 -0400
To: Jean Delvare <khali@linux-fr.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070418174256.GB5577@csclub.uwaterloo.ca>
References: <11765554074106-git-send-email-hskinnemoen@atmel.com> <20070414163418.20490fe2@dhcp-252-105.norway.atmel.com> <20070414192807.60bdf84b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414192807.60bdf84b@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 07:28:07PM +0200, Jean Delvare wrote:
> Otherwise it looks OK to me, I take the patch. If others have comments
> or objections, just speak up and submit incremental patches as needed.
> 
> Now I would like to see platform code actually using this.

Any idea how similar this new driver is to the scx200_i2c driver?  As
far as I can tell that driver is already a bit banged i2c over gpio
lines.

--
Len Sorensen
