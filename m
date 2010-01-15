Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab0AOSXl (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999Ab0AOSXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:23:40 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:58792 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758001Ab0AOSXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:23:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FTNAmr/OeG46mt+2cFDc4OXBhV3JIfA0XeOn0jY7QLQMjrlsecLtmg6owGThBVHH2cCUE86QJqaGU8KftO9B9sWu/391KjvwjB2cGxvJVzgN3cSWKvk5lsNSsv8mA8JR;
Date: Fri, 15 Jan 2010 10:23:37 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <torvalds@linux-foundation.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 1/2] resource: align functions now return start of
 resource
Message-ID: <20100115102337.43c47b02@jbarnes-piketon>
In-Reply-To: <1262364050-8540-1-git-send-email-linux@dominikbrodowski.net>
References: <20100101163811.GA8124@comet.dominikbrodowski.net>
	<1262364050-8540-1-git-send-email-linux@dominikbrodowski.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Jan 2010 17:40:49 +0100
Dominik Brodowski <linux@dominikbrodowski.net> wrote:

> As suggested by Linus, align functions should return the start
> of a resource, not void. An update of "res->start" is no longer
> necessary.

Applied these two to my linux-next branch, thanks Dominik.

-- 
Jesse Barnes, Intel Open Source Technology Center
