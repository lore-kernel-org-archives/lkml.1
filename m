Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbXLEQ1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbXLEQ1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXLEQ1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:27:35 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52050 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbXLEQ1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:27:34 -0500
Subject: Re: [RFC PATCH 1/5] Remove existing directory listing
	implementation
From: Dave Hansen <haveblue@us.ibm.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20071205143830.GD2471@in.ibm.com>
References: <20071205143718.GC2471@in.ibm.com>
	 <20071205143830.GD2471@in.ibm.com>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 08:27:23 -0800
Message-Id: <1196872044.18685.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-05 at 20:08 +0530, Bharata B Rao wrote:
> Remove the existing readdir implementation.

You may have had a better description in your 0/5 mail, but this is what
goes into the git log in the end, so I think you need to beef this up a
bit.  

-- Dave

