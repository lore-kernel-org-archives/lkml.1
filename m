Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbZJNLqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbZJNLqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 07:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZJNLqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 07:46:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:37057 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbZJNLqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 07:46:08 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
Date: Wed, 14 Oct 2009 13:45:29 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alexander Huemer <alexander.huemer@sbg.ac.at>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
References: <4ABBB8C2.2080901@sbg.ac.at> <4AD422F2.4080308@sbg.ac.at> <4AD473F9.7090606@kernel.org>
In-Reply-To: <4AD473F9.7090606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910141345.30177.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 13 octobre 2009, Tejun Heo a écrit :
> Alexander Huemer wrote:
> > i compiled gcc in a loop over night, 14 times. no error.
> > it really seams i2c_i801 was the cause...
> > unfortunately i still don't know how i can extract the part of the gcc
> > compilation process that causes the error on an affected kernel.
> > that would enable me to create a simple test program.
> 
> Given that i2c is used for temperature monitoring, I think it is not
> triggered by any single step of the compiling but rather by the
> accumulated heat load during compilation.  Let's wait for Jean to
> chime in.  :-)

Sorry, I'm somewhat busy at the moment, I'll give it a look as soon
as I get a moment.

-- 
Jean Delvare
Suse L3
