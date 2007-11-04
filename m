Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbXKDTnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbXKDTnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 14:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbXKDTnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 14:43:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:48596 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbXKDTnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 14:43:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VABEUG+vAcX8IUPOvCoFK/tSpTGx2ar5SGEmUekzouWb3wobuWMva1wuwAt1LpxfoIV+3EhTngrj9eu4IuHoup++neueB5QgHIONxXVNbXrZj1VirHfetkWWTMgPjR4SgdugTXzpI2sgwwEZyu9DfD+HTHJJKKcxijckeJqSBEQ=
Message-ID: <e5bfff550711041143i7be3cff7kd4903ed43cb4e232@mail.gmail.com>
Date: Sun, 4 Nov 2007 20:43:01 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: duplicated include files
In-Reply-To: <e5bfff550711041141h612a24cdrcdb5baa35907989d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e5bfff550711041141h612a24cdrcdb5baa35907989d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/4/07, Marco Costalba <mcostalba@gmail.com> wrote:
> make includecheck does not work for me. Linux tree is from latest git.
>
> bash-3.2$ pwd
> /git/linux-2.6
>
> bash-3.2$ make includecheck
> find * \( -name SCCS -o -name BitKeeper -o -name .svn -o -name CVS -o

BTW what's that 'BitKeeper' fossil here?
