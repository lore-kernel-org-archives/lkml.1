Return-Path: <linux-kernel-owner+w=401wt.eu-S1751203AbYH2OyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbYH2OyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbYH2Oxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:53:49 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:58076 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYH2Oxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=OIXEL9vBpEZZsrwPit66lKRanCTDyKdc0W+bYJbncQHzjivyTMh9DP7nTU/YMVxc31
         HqIjBm/i6S+nnvOuoSLlxjiy2BFhEHenYUVWuGIFaYX1h/zaUfKOwTDG1nOT/6zCclAf
         IJQCe0dddyomt8hYGdUHhs7026tk43VPnC9lQ=
Message-ID: <48B80D33.5050806@gmail.com>
Date: Fri, 29 Aug 2008 16:52:35 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
       Peer Chen <pchen@nvidia.com>
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca>
In-Reply-To: <48B80B40.5060002@shaw.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> (ccing linux-ide)
> 
> Tejun, another one of these reset issues?

Yeah, looks like it.  I just sent the patch for #upstream-fixes and will
forward it to -stable once it gets into #upstream-fixes.

  http://article.gmane.org/gmane.linux.ide/34077

Thanks.

-- 
tejun
