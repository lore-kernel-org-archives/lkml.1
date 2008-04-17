Return-Path: <linux-kernel-owner+w=401wt.eu-S933970AbYDQPix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970AbYDQPix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762016AbYDQPio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:38:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34601 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761250AbYDQPin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:38:43 -0400
Date: Thu, 17 Apr 2008 08:44:33 -0700
From: Greg KH <greg@kroah.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] Tell git about security/selinux/include/audit.h
Message-ID: <20080417154433.GA2120@kroah.com>
References: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org> <751bc5f7460a0337b7e463bd9a7c4ad60ed6176e.1208428766.git.jmorris@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <751bc5f7460a0337b7e463bd9a7c4ad60ed6176e.1208428766.git.jmorris@namei.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 11:06:07AM +0000, James Morris wrote:
> Signed-off-by: James Morris <jmorris@namei.org>
> ---
>  security/selinux/include/audit.h |   65 ++++++++++++++++++++++++++++++++++++++

Shouldn't this be merged with the previous patch that needed this?

That way no one gets hit with a build error doing a 'git bisect'.

thanks,

greg k-h
