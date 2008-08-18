Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbYHRUmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbYHRUmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYHRUmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:42:11 -0400
Received: from outbound-mail-146.bluehost.com ([67.222.38.36]:38375 "HELO
	outbound-mail-146.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754250AbYHRUmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:42:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=eruKHVUmLIZawPPbNSvCgIkVDP+B2WtFiDSa36wzUaWxpy0G+FzhWxwUdvikpUv1g/snLgKsUP2gDoW4UeiZTGKzNVaMnixlaZJtake79jnOUw5QyY2WyOqAJWlohlMs;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Date: Mon, 18 Aug 2008 13:41:56 -0700
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org
References: <for-27-patch1-0@bga.com> <20080816062259.GB20541@kroah.com> <20080817210659.06601a3b@hyperion.delvare>
In-Reply-To: <20080817210659.06601a3b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181341.56915.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 17, 2008 12:06 pm Jean Delvare wrote:
> Subject: PCI: Check dynids driver_data value for validity
>
> Only accept dynids those driver_data value matches one of the driver's
> pci_driver_id entry. This prevents the user from accidentally passing
> values the drivers do not expect.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Milton Miller <miltonm@bga.com>
> Cc: Greg KH <greg@kroah.com>

Applied to linux-next, thanks Jean.

Jesse
