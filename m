Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbYGYTeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbYGYTeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 15:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYGYTeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 15:34:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:26670 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYGYTeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 15:34:05 -0400
Message-ID: <fa686aa40807251234n74e4cd75yd6313fa394533625@mail.gmail.com>
Date: Fri, 25 Jul 2008 15:34:03 -0400
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH v3 2/4] spi: split up spi_new_device() to allow two stage registration.
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       jonsmirl@gmail.com
In-Reply-To: <200807251200.45321.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
	 <20080725073316.8485.84001.stgit@trillian.secretlab.ca>
	 <200807251200.45321.david-b@pacbell.net>
X-Google-Sender-Auth: 1b0002cdcbe8e054
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 3:00 PM, David Brownell <david-b@pacbell.net> wrote:
> On Friday 25 July 2008, Grant Likely wrote:
>>
>> This change is in preparation for adding an OF device tree parser to
>> generate spi_devices based on data in the device tree.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>
> Given the comment fixes noted above and below:
>
>
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Cool, I'll get all this fixed.  Thanks.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
