Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbYCZH7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbYCZH7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYCZH7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:59:41 -0400
Received: from smtp7-g19.free.fr ([212.27.42.64]:33986 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYCZH7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:59:41 -0400
Date: Wed, 26 Mar 2008 08:56:39 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: "Chris Snook" <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: RAID-1 performance under 2.4 and 2.6
Message-ID: <20080326085639.3c7d3152@galadriel.home>
In-Reply-To: <e2e108260803260015l5e8ba4f7n4fdbac771b13cbba@mail.gmail.com>
References: <20080325194306.4ac71ff2@galadriel.home>
	<47E975F8.3000702@redhat.com>
	<e2e108260803260015l5e8ba4f7n4fdbac771b13cbba@mail.gmail.com>
Organization: Intellique
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wed, 26 Mar 2008 08:15:15 +0100 vous écriviez:

> If you want to benchmark write speed, you should add
> oflag=direct,dsync to the dd command line. For benchmarking read speed
> you should specify iflag=direct. Or, even better, you can use xdd with
> the flags -dio -processlock.

Thanks for the tip, I'll try these.

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
