Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbZICOl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbZICOl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZICOlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:41:25 -0400
Received: from gherkin.frus.com ([192.158.254.49]:36566 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZICOlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:41:25 -0400
Date: Thu, 3 Sep 2009 09:41:26 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] sg: fix oops in the error path in sg_build_indirect()
Message-ID: <20090903144126.GA22411@gherkin.frus.com>
References: <20090903033945.GA20755@gherkin.frus.com> <20090903142708.0b820ca1@leela>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903142708.0b820ca1@leela>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 02:27:08PM +0200, Michal Schmidt wrote:
> When the allocation fails in sg_build_indirect(), an oops happens in
> the error path. It's caused by an obvious typo.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> Reported-by: Bob Tracy <rct@gherkin.frus.com>

ACK, and thanks.

--Bob
