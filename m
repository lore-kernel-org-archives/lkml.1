Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZBVLH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZBVLH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 06:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbZBVLHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 06:07:18 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:54109 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbZBVLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 06:07:17 -0500
Date: Sun, 22 Feb 2009 11:07:13 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ath5k phy0: noise floor calibration timeout
Message-ID: <20090222110713.GA5538@silver.sucs.org>
References: <1234102609.6945.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234102609.6945.3.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 03:16:49PM +0100, Thomas Meyer wrote:
> My kernel message ring buffer seems to be flooded by these messages:
> 
> Should I care?
> 
> kernel version: v2.6.29-rc3-746-g396bb7a
> 
> [   84.204328] ath5k phy0: noise floor calibration timeout (2422MHz)

No, you probably shouldn't care -
http://www.mail-archive.com/ath5k-devel@lists.ath5k.org/msg01463.html .
Sounds like it's a known (but low impact) issue.

-- 
Sitsofe | http://sucs.org/~sits/
