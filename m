Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbYFXRUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbYFXRUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYFXRUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:20:04 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:33988 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbYFXRUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:20:03 -0400
Subject: merge conflicts with tip/master
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 24 Jun 2008 10:18:57 -0700
Message-Id: <1214327937.27577.6.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

While working with tip/master...after following the steps in the readme
@ http://people.redhat.com/mingo/tip.git/readme.txt

I usually do any changes and manage them using "quilt". 
Once the changes are pushed upstream, i do a "quilt pop"
and generally try a "git pull" to check for any new changes, along with
the change that was just pushed. 

This method works fine for me with Linus's tree. 
But with tip/master i usually get "merge conflicts"

Am i doing something wrong over here...am i supposed to not use git pull
for updating the local tip/master copy ? 

Thanks,
Alok


