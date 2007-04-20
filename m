Return-Path: <linux-kernel-owner+w=401wt.eu-S2992695AbXDTI5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992695AbXDTI5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992705AbXDTI5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:57:09 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:57349 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992695AbXDTI5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:57:07 -0400
In-Reply-To: <20070420082714.4f10f186@localhost.localdomain>
References: <20070420082714.4f10f186@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <8ecb814f5d309b596d2a52cde33b16d3@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Jean Delvare <khali@linux-fr.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH][RFC][POWERPC] i2c: adds support for i2c bus on 8xx
Date: Fri, 20 Apr 2007 10:57:04 +0200
To: Vitaly Bordug <vitb@kernel.crashing.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +				compatible = "fsl-i2c-cpm";

"fsl,i2c-cpm" instead.


Segher

