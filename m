Return-Path: <linux-kernel-owner+w=401wt.eu-S934705AbYEBQp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbYEBQp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934010AbYEBQpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:45:06 -0400
Received: from testure.choralone.org ([194.9.77.134]:52038 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933989AbYEBQpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:45:04 -0400
Date: Fri, 2 May 2008 12:44:56 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Remove Asus EEE UDMA/33 limitation.
Message-ID: <20080502164456.GA19054@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	linux-ide@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080502154458.GA10567@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502154458.GA10567@codemonkey.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 11:44:58AM -0400, Dave Jones wrote:
 > The Asus Eee PC prints this during bootup..

never mind, someone just pointed out 01ce2601e4ba354fe1e25bb940817570d0c8ed4f
which does the same thing.

	Dave

-- 
http://www.codemonkey.org.uk
