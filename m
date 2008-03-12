Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYCLWl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYCLWl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYCLWlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:41:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:52336 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYCLWlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:41:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qff/rAbBFHkj4hDqg2t8VIIFvs4uVvEQ3Nami6NkQnCP4/1hANnWSs4liBMIaCdOOijAD8q1bTGikYkpbznHpTYnWNl3XhZuH/EVi/xMUC4+kYQscnIEXECxggRyBYnOCtL4Ifk3lHstd7FDRbdATbavf1XIDBcKXEJd6KrjbaI=
Message-ID: <3d8471ca0803121541n1aec2fa0l1226466a65977227@mail.gmail.com>
Date: Wed, 12 Mar 2008 23:41:10 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: /proc/loadavg: total number of processes is wrong?
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <47D85916.5080203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D85916.5080203@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/08, Chuck Ebbert <cebbert@redhat.com> wrote:
>  /proc/loadavg says 192 processes, but ps only sees 121.

'ps ax' does not include threads?

-- 
Guillaume
