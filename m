Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZBFNyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZBFNyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbZBFNyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:54:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:17971 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096AbZBFNyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:54:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,391,1231142400"; 
   d="scan'208";a="384639530"
Date: Fri, 6 Feb 2009 14:56:59 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Mark WM835x USB_SLV_500MA bit as accessible
Message-ID: <20090206135658.GB3341@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1231944901-4901-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231944901-4901-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 02:55:01PM +0000, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8350-regmap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
Applied, thanks.

 
> diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
> index 68887b8..9a4cc95 100644
> --- a/drivers/mfd/wm8350-regmap.c
> +++ b/drivers/mfd/wm8350-regmap.c
> @@ -3188,7 +3188,7 @@ const struct wm8350_reg_access wm8350_reg_io_map[] = {
>  	{ 0x7CFF, 0x0C00, 0x7FFF }, /* R1   - ID */
>  	{ 0x0000, 0x0000, 0x0000 }, /* R2 */
>  	{ 0xBE3B, 0xBE3B, 0x8000 }, /* R3   - System Control 1 */
> -	{ 0xFCF7, 0xFCF7, 0xF800 }, /* R4   - System Control 2 */
> +	{ 0xFEF7, 0xFEF7, 0xF800 }, /* R4   - System Control 2 */
>  	{ 0x80FF, 0x80FF, 0x8000 }, /* R5   - System Hibernate */
>  	{ 0xFB0E, 0xFB0E, 0x0000 }, /* R6   - Interface Control */
>  	{ 0x0000, 0x0000, 0x0000 }, /* R7 */
> -- 
> 1.5.6.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
