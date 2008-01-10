Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYAJVrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYAJVrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYAJVrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:47:33 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:37665 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYAJVrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:47:32 -0500
Date: Thu, 10 Jan 2008 15:47:36 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       serue@us.ibm.com
Subject: Re: [RFC][PATCH 0/4] kill open files traverse on remount ro
Message-ID: <20080110214736.GA9007@sergelap.austin.ibm.com>
References: <20080110190657.92A8B61F@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110190657.92A8B61F@kernel>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (haveblue@us.ibm.com):
> This is just RFC for now.  I'm tracking down a wee bit of
> list corruption.  But, I wanted to send out so you could
> compare to the last approach.

Looks reasonable to me, and quite readable.

So after this set, you'd be able to remove s_files altogether?

-serge
