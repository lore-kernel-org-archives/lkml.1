Return-Path: <linux-kernel-owner+w=401wt.eu-S965437AbXCGNo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965437AbXCGNo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965485AbXCGNo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:44:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965437AbXCGNo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:44:58 -0500
Date: Wed, 7 Mar 2007 14:44:47 +0100
From: Karel Zak <kzak@redhat.com>
To: Marcos Dione <mdione@grulic.org.ar>
Cc: linux-kernel@vger.kernel.org
Subject: Re: UUID support
Message-ID: <20070307134447.GE25806@petra.dvoda.cz>
References: <20070307112422.GA19193@plantalta.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307112422.GA19193@plantalta.homelinux.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 08:24:22AM -0300, Marcos Dione wrote:
>     I'm being forced by my distro to use UUDIs to specify the boot device by
> UUID. the problem is I don't know how to add UUID support to the kernl, that is,
> I don't know which option I should enable.

 http://lkml.org/lkml/2005/6/15/21

 Please, try Mr.Google and "root=UUID"

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
