Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbXDYAs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbXDYAs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 20:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbXDYAs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 20:48:59 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbXDYAs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 20:48:58 -0400
Message-ID: <462EA523.8090909@zytor.com>
Date: Tue, 24 Apr 2007 17:47:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: clameter@sgi.com
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>
In-Reply-To: <20070424222105.883597089@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW, this would also let zisofs remove the ugly hacks we currently 
employ to deal with compression blocks.

	-hpa

