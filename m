Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbZANUq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbZANUq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbZANUqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:46:45 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:24433 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbZANUqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:46:44 -0500
X-IronPort-AV: E=Sophos;i="4.37,263,1231113600"; 
   d="scan'208";a="129019642"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org
Subject: Re: CPA warning when running dmidecode on 2.6.29-rc1
References: <adaab9tivab.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 14 Jan 2009 12:46:43 -0800
In-Reply-To: <adaab9tivab.fsf@cisco.com> (Roland Dreier's message of "Wed, 14
	Jan 2009 10:42:36 -0800")
Message-ID: <adawscxhaz0.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jan 2009 20:46:43.0806 (UTC) FILETIME=[3590F7E0:01C97689]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Never mind, this seems to be fixed by
58dab916dfb57328d50deb0aa9b3fc92efa248ff.

 - R.

