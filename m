Return-Path: <linux-kernel-owner+w=401wt.eu-S1763586AbZE1SPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763586AbZE1SPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbZE1SPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:15:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:43755 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbZE1SPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M6yO1AoyV0ELqVOQKW25YJbzTtRqE8pih6t6AeWscDHXuy1f4h1eZVyQfbVDOZa5NF
         tm246KvvZ7EUAXBk8jD5cP+/JoXD6fmbD58YqmW7GsI3eLxmQDGcE3ZwyEoYGt7gGfKF
         zgV2l0hqBmADsrFRvIN8lz5a533P3bot2nUdM=
Subject: Re: [PATCH v3] MFD: PCAP driver
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Harald Welte <laforge@gnumonks.org>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       openezx-devel <openezx-devel@lists.openezx.org>
In-Reply-To: <20090528174635.GA29797@sortiz.org>
References: <1243399356.2263.46.camel@brutus>
	 <20090528174635.GA29797@sortiz.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 May 2009 15:14:31 -0300
Message-Id: <1243534472.5097.1.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Qui, 2009-05-28 às 19:46 +0200, Samuel Ortiz escreveu:
> Hi Daniel,

Hi! :)

> I'd actually prefer the void pointer to be a pcap_chip one.
> Otherwise, the patch looks good to me.

Ok, will do. Thanks!

-- 
Daniel Ribeiro

