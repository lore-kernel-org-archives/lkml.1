Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYAZJt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYAZJt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYAZJtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:49:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:55513 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbYAZJtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:49:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g5mJJkAp/2+KJWOZzZEsh7R7s00m9p14JAM537iFdoJNch3HWrEcivBHGxvATzC22s0QMxioR89ZAMrj7hPUs7KZGRdZPhAEtU7u/sMJwJ/A0WUGLyC0jwHZZ4eXT6T2Oc9E+ifQFnpoa4FUE3erQd7PYviqkfVVUXsVoC3UxBQ=
Message-ID: <7fac565a0801260149j7d6d48demfb49d2bb0d5a952@mail.gmail.com>
Date: Sat, 26 Jan 2008 11:49:17 +0200
From: "Alexey Eremenko" <al4321@gmail.com>
To: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 3/8] SVM: add module parameter to disable NestedPaging
In-Reply-To: <20080126072556.GB21476@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
	 <1201294393-22613-4-git-send-email-joerg.roedel@amd.com>
	 <2D848F959C03D945A84E9EDE7F7BFE4274021D@orsmsx424.amr.corp.intel.com>
	 <20080126072556.GB21476@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Generally I see no problem with it. But at least for NPT I don't see a
> reason why someone should want to disable it on a VM basis (as far as it
> works stable). Avi, what do you think?
>

1. This is more user-friendly and easier-to-find

2. A lot of people would like to view (and Demo) it side-by-side.

3. Useful for BETA-testing of KVM.

-- 
-Alexey Eremenko "Technologov"
