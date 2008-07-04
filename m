Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbYGDQKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbYGDQKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYGDQJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:09:58 -0400
Received: from mx-a.polytechnique.fr ([129.104.30.14]:42508 "EHLO
	mx-a.polytechnique.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbYGDQJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:09:57 -0400
Message-ID: <486E4AE8.1040108@crans.org>
Date: Fri, 04 Jul 2008 18:08:08 +0200
From: =?ISO-8859-15?Q?Mathieu_B=E9rard?= <Mathieu.Berard@crans.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.25 to 2.6.26-rc8 regression  (related to ahci and acpi _GTF)
References: <4869FB3C.4060509@crans.org> <200807011614.21491.rjw@sisk.pl> <486AEE29.2010506@gmail.com> <486B4490.7080904@crans.org> <486DA8DA.4070601@gmail.com>
In-Reply-To: <486DA8DA.4070601@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo a écrit :
>
>
> Can you please test the attached patch?
>
>   
Hi,
tested again latest git: It works.

I am yet to test more fragile features such as suspend or hibernation,
but the obvious regression is gone.
(Yet I still doesn't understand why it used to work with DIPM)

Thanks.

-- 
Mathieu
