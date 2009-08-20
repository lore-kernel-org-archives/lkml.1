Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZHTNTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZHTNTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbZHTNTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:19:24 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:53239 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZHTNTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:19:23 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: jmorris@namei.org
Cc: sds@tycho.nsa.gov, gregkh@suse.de, casey@schaufler-ca.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
In-Reply-To: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 20 Aug 2009 09:18:05 -0400
Message-Id: <1250774285.2542.72.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Casey has withdrawn his NAK for the patch I guess the only other
concern was about the generality of the solution from Eric. Did Steve's
response adequately address this or are there any other questions that
people need answered before Greg can take the patch.

Dave

