Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZIWAag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZIWAag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbZIWAaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:30:35 -0400
Received: from mail001.aei.ca ([206.123.6.130]:57198 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbZIWAaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:30:35 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Nitin Gupta <ngupta@vflare.org>
Subject: Re: TODO file for ramzswap
Date: Tue, 22 Sep 2009 20:30:32 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31.1-rc1-crc; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <d760cf2d0909220302h1d74915atde0f6fe3b0fb3d6c@mail.gmail.com>
In-Reply-To: <d760cf2d0909220302h1d74915atde0f6fe3b0fb3d6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909222030.33261.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009 06:02:33 Nitin Gupta wrote:
> TODO file for ramzswap.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> 
> ---
>  drivers/staging/ramzswap/TODO |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/ramzswap/TODO b/drivers/staging/ramzswap/TODO
> new file mode 100644
> index 0000000..bac40d6
> --- /dev/null
> +++ b/drivers/staging/ramzswap/TODO
> @@ -0,0 +1,6 @@
> +TODO:
> +	- Add support for swap notifiers
> +	- Remove CONFIG_ARM hack

Is locking still an issue with SMP?  If so, its probably a good item for the todo list.

TIA
Ed Tomlinson
