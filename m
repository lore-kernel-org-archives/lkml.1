Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbYKFRfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbYKFRfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYKFRfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:35:00 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38587 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750903AbYKFRe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:34:59 -0500
Date: Thu, 6 Nov 2008 12:33:27 -0500
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Staubach <staubach@redhat.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH]: ext4: fix big endian
Message-ID: <20081106173327.GF18939@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Peter Staubach <staubach@redhat.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com> <20081106163846.GA1381@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106163846.GA1381@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 11:38:46AM -0500, Christoph Hellwig wrote:
> 
> Yes.  And if someone ran sparse over the code both the initial error
> and this varaint would be trivial to spot..
> 

That's how Aneesh found it.  :-)

					- Ted
