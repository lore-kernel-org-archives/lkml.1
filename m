Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYJWRxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYJWRxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbYJWRxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:53:13 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:42026 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754828AbYJWRxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:53:12 -0400
Date: Thu, 23 Oct 2008 13:53:11 -0400
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, ben-linux@fluff.org
Subject: Re: scx200_i2c driver fails to detect any i2c devices in 2.6.26
Message-ID: <20081023175311.GC5682@csclub.uwaterloo.ca>
References: <20081023165419.GA5682@csclub.uwaterloo.ca> <20081023193519.2af62bb5@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023193519.2af62bb5@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 07:35:19PM +0200, Jean Delvare wrote:
> Oh, BTW... this patch is missing your Signed-off-by.

Yeah I know.  I didn't think it would be accepted with I2C_CLASS_ALL so
I was expecting to have to make another one.  I will send a new one with
a signed off.

-- 
Len Sorensen
