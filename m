Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbXHUUlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbXHUUlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbXHUUkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:40:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:40856 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbXHUUkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:40:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=GtisRRNl7utb4+9bNEcfRhW+QDQw5z2a0gOLOOfZUuncCBQTRIynzNUfvmoptxPzp+QOV0MNJzEgUOPYbKNyzd2vFwiwAvdPxojmM6UVhhdkKPSFdQLISNzqKA0m80vqsbemREBwIhaVEzQMkX3khmCpEgtpn8ZzI486HCJc06w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 1/4] ide: add ide_dev_is_sata() helper
Date: Tue, 21 Aug 2007 22:36:04 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200708192259.08171.sshtylyov@ru.mvista.com>
In-Reply-To: <200708192259.08171.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708212236.04837.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, Sergei Shtylyov wrote:
> Make the SATA drive detection code from eighty_ninty_three() into inline
> ide_dev_is_sata() helper fixing it along the way to be more strict while
> checking word 80 for the reserved values...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied
