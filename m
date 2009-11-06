Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZKFJMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZKFJMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 04:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZKFJMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 04:12:15 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:50605 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbZKFJMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 04:12:13 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 07/11] sysctl: s390 Use the compat_sys_sysctl
Date: Fri, 6 Nov 2009 10:12:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-self-00026-g91d3f9b; KDE/4.3.2; i686; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Carsten Otte <cotte@de.ibm.com>
References: <m1tyx8trik.fsf@fess.ebiederm.org> <1257468114-6823-7-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1257468114-6823-7-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911061012.17239.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 06 November 2009 01:41:50 schrieb Eric W. Biederman:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Now that we have a generic 32bit compatibility implementation
> there is no need for s390 to implement it's own.
> 
> Cc: Carsten Otte <cotte@de.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>

You should have CCed Martin & Heiko, since this is cleary not KVM.
I took a look anyway ;-)

> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Patch looks good.

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
