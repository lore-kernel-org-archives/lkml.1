Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbZI2Tay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbZI2Tay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 15:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbZI2Tax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 15:30:53 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56403 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZI2Taw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 15:30:52 -0400
Date: Tue, 29 Sep 2009 15:19:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 2.6.32-rc2: wlan rt73 dead
Message-ID: <20090929191948.GE2678@tuxdriver.com>
References: <20090929170615.GA5539@fancy-poultry.org> <20090929191125.GA5640@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929191125.GA5640@fancy-poultry.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 09:11:25PM +0200, Heinz Diehl wrote:

> And that's it. Tha adapter is "off", and no connection is possible. It's
> strongly 2.6.32-rc2 related, no problems with any other kernel before.

Could you do a git bisect?  Also, please Cc:
linux-wireless@vger.kernel.org for your response...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
