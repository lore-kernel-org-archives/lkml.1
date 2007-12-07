Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbXLGQvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbXLGQvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 11:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbXLGQvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 11:51:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbXLGQvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 11:51:05 -0500
Date: Fri, 7 Dec 2007 11:51:01 -0500
From: Dave Jones <davej@redhat.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Possible EXT2 race
Message-ID: <20071207165101.GA26631@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"linux-os (Dick Johnson)" <linux-os@analogic.com>,
	Linux kernel <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.61.0712070808030.4642@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0712070808030.4642@chaos.analogic.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2007 at 08:15:42AM -0500, linux-os (Dick Johnson) wrote:

 > Dec  7 04:05:55 chaos kernel: sd 0:0:1:0: [sdb] Add. Sense: Peripheral device write fault
 
This sounds more like a hardware problem.

	Dave

-- 
http://www.codemonkey.org.uk
