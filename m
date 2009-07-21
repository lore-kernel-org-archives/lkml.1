Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZGUQoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZGUQoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbZGUQoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:44:17 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:37364 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbZGUQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:44:16 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: jmorris@namei.org
Cc: sds@tycho.nsa.gov, gregkh@susa.de, casey@schaufler-ca.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
In-Reply-To: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 21 Jul 2009 12:34:27 -0400
Message-Id: <1248194067.10726.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've found a problem with the patch that I want to fix. So I will be
posting another version of it soon.

Dave

