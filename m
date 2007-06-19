Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbXFSJoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbXFSJoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbXFSJoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:44:39 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:35083 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbXFSJoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:44:39 -0400
X-Greylist: delayed 1951 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 05:44:38 EDT
Date: Tue, 19 Jun 2007 11:12:00 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 5/6] Move psw_set_key.
Message-ID: <20070619091200.GA1277@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20070619084516.457715754@de.ibm.com> <20070619084642.673859525@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070619084642.673859525@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 10:45:21AM +0200, Martin Schwidefsky wrote:
> Move psw_set_key() from ptrace.h to processor.h which is a more
> suitable place for it. In addition the moves makes the function
> invisible to user space.

Hmm, this does not really describe the changes.

Bastian

-- 
Violence in reality is quite different from theory.
		-- Spock, "The Cloud Minders", stardate 5818.4
